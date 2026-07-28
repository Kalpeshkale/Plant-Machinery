using BCrypt.Net;
using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.Auth;
using PNM.Infrastructure.Context;
using PNM.Service.Services.Interfaces;

namespace PNM.Service.Services
{
    public class AuthService : IAuthService
    {
        private readonly PnmDbContext _context;
        private readonly IJwtService _jwtService;

        public AuthService(PnmDbContext context, IJwtService jwtService)
        {
            _context = context;
            _jwtService = jwtService;
        }

        public async Task<LoginResponse?> LoginAsync(LoginRequest request)
        {
            var admin = await _context.TblAdmins
                .Include(x => x.Role)
                .FirstOrDefaultAsync(x =>
                    x.EmpId == request.EmpId &&
                    x.IsActive);

            if (admin != null)
            {
                bool validPwd = BCrypt.Net.BCrypt.Verify(request.Password, admin.PasswordHash);
                if (!validPwd) return null;

                return new LoginResponse
                {
                    UserId     = admin.AdminId,
                    UserName   = admin.FullName,
                    DeptId     = admin.DeptId,
                    RoleId     = admin.RoleId,
                    RoleName   = admin.Role.Role,
                    UserSource = "ADMIN",
                    Token      = _jwtService.GenerateToken(admin)
                };
            }

            // ── STEP 2: Check tbl_User (Operators) ────────────────────────────
            var user = await _context.TblUsers
                .Include(x => x.Role)
                .FirstOrDefaultAsync(x =>
                    x.EmpId == request.EmpId &&
                    x.IsActive);

            if (user == null) return null;

            bool validUserPwd = BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash);
            if (!validUserPwd) return null;

            return new LoginResponse
            {
                UserId     = user.UserId,
                UserName   = user.FullName ?? user.UserName,
                DeptId     = user.DeptId,
                RoleId     = user.RoleId,
                RoleName   = user.Role.Role,
                UserSource = "OPERATOR",
                Token      = _jwtService.GenerateToken(user)
            };
        }
    }
}
