var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

var app = builder.Build();

// Configure the HTTP request pipeline.

app.UseHttpsRedirection();
app.UseAuthorization();
app.UseWebSockets(new() { KeepAliveInterval = TimeSpan.FromMinutes(1) });

app.MapControllers();

app.Run();
