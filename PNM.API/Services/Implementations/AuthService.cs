using BCrypt.Net;
using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.Auth;
using PNM.Core.DTO.Auth;
using PNM.Infrastructure.Context;
using PNM.Service.Services.Implementations;
using PNM.Service.Services.Interfaces;
namespace PNM.Service.Services
{
    public class AuthService : IAuthService
    {
        private readonly PnmDbContext _context;
        private readonly IJwtService _jwtService;

        public AuthService(
        PnmDbContext context,
        IJwtService jwtService)
        {
            _context = context;
            _jwtService = jwtService;
        }

        public async Task<LoginResponse?> LoginAsync(LoginRequest request)
        {
            var user = await _context.TblUsers
            .Include(x => x.Role)
            .FirstOrDefaultAsync(x =>
                x.EmpId == request.EmpId &&
                x.IsActive);

            if (user == null)
                return null;

            bool isValidPassword = BCrypt.Net.BCrypt.Verify(
                request.Password,
                user.PasswordHash);

            if (!isValidPassword)
                return null;

            return new LoginResponse
            {
                UserId = user.UserId,
                UserName = user.UserName,
                DeptId = user.DeptId,
                RoleId = user.RoleId,
                RoleName = user.Role.Role,
                Token = _jwtService.GenerateToken(user)
            };
        }
    }
}