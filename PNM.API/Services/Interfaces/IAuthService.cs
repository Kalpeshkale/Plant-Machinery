using PNM.Core.DTO.Auth;

namespace PNM.Service.Services.Interfaces
{
    public interface IAuthService
    {
        Task<LoginResponse?> LoginAsync(LoginRequest request);
    }
}