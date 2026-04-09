# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# STAGE 1 : Build — SDK complet pour compiler
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
# Copie d'abord uniquement le .csproj pour profiter du cache Docker
# Si le code change mais pas les dépendances → restore pas refait
COPY DevopsApi/DevopsApi.csproj DevopsApi/
RUN dotnet restore DevopsApi/DevopsApi.csproj
# Maintenant copie tout le reste du code
COPY . .
RUN dotnet publish DevopsApi/DevopsApi.csproj \
    -c Release \
    -o /app/publish \
    --no-restore
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# STAGE 2 : Runtime — image finale légère
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app

# Créer utilisateur non-root
RUN useradd -m appuser

# Donner les droits
RUN chown -R appuser:appuser /app

# Passer en utilisateur non-root
USER appuser

# Copier les fichiers
COPY --from=build /app/publish .

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

ENTRYPOINT ["dotnet", "DevopsApi.dll"]