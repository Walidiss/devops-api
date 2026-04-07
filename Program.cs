var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();
app.MapGet("/api/hello", () => new {
message = "DevOps fonctionne version 2",
timestamp = DateTime.UtcNow,
server = Environment.MachineName
});
app.MapGet("/health", () => "OK");
app.Run();
