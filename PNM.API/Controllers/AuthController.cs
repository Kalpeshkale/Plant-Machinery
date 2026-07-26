using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.Auth;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;

namespace PNM.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IAuthService _authService;

        public AuthController(IAuthService authService)
        {
            _authService = authService;
        }

        [HttpPost("Login")]
        public async Task<IActionResult> Login(LoginRequest request)
        {
            var result = await _authService.LoginAsync(request);

            if (result == null)
            {
                return Unauthorized(
                    ApiResponseHelper.Failure<object>(
                        "Invalid Employee Id or Password."
                    ));
            }

            return Ok(
                ApiResponseHelper.Success(
                    result,
                    "Login successful."
                ));
        }
    }
}