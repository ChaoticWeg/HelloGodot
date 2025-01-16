using Microsoft.AspNetCore.Mvc;
using System.Text;

namespace HelloGodotServer.Controllers;

[ApiController]
public class GameController(ILogger<GameController> logger)
    : ControllerBase
{
    [Route("ws")]
    public async Task Get(CancellationToken cancellationToken)
    {
        if (!HttpContext.WebSockets.IsWebSocketRequest)
        {
            HttpContext.Response.StatusCode = StatusCodes.Status400BadRequest;
            return;
        }

        using var webSocket = await HttpContext.WebSockets.AcceptWebSocketAsync();
        logger.LogInformation("WebSocket connected");

        var buffer = new byte[1_024 * 4];
        var result = await webSocket.ReceiveAsync(new ArraySegment<byte>(buffer), cancellationToken);

        while (!result.CloseStatus.HasValue)
        {
            var str = Encoding.UTF8.GetString(buffer, 0, result.Count);
            logger.LogInformation("{str}", str);

            result = await webSocket.ReceiveAsync(new ArraySegment<byte>(buffer), cancellationToken);
        }
    }
}
