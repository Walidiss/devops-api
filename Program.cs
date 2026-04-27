using OpenTelemetry.Metrics;

var builder = WebApplication.CreateBuilder(args);
// OpenTelemetry — métriques ASP.NET Core
builder.Services.AddOpenTelemetry()
    .WithMetrics(metrics =>
    {
        metrics
            .AddAspNetCoreInstrumentation()  // requêtes HTTP auto
            .AddRuntimeInstrumentation()     // GC, threads .NET
            .AddPrometheusExporter();        // expose /metrics
    });
var app = builder.Build();

app.MapGet("/api/hello", () => new {

    message = "DevOps v7 — Kubernetes version!",

    timestamp = DateTime.UtcNow,

    server = Environment.MachineName

});

app.MapGet("/api/config", () => new {

    environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT"),

    dbHost = Environment.GetEnvironmentVariable("DB_HOST") ?? "non configuré",

    version = "2.0.0"

});

app.MapGet("/health", () => "OK");

app.Run();