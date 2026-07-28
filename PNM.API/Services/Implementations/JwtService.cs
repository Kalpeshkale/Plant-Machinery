using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace PNM.Service.Services.Implementations;

public class JwtService : IJwtService
{
    private readonly IConfiguration _configuration;

    public JwtService(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    // ── Operator (tbl_User) ───────────────────────────────────────────────
    public string GenerateToken(TblUser user)
    {
        var claims = new[]
        {
            new Claim(ClaimTypes.NameIdentifier, user.UserId.ToString()),
            new Claim(ClaimTypes.Name, user.FullName ?? user.UserName),
            new Claim("EmpId", user.EmpId),
            new Claim("Source", "USER"),
            new Claim(ClaimTypes.Role, user.Role.Role)
        };

        return BuildToken(claims);
    }

    // ── Admin / Site Incharge (tbl_Admin) ─────────────────────────────────
    public string GenerateToken(TblAdmin admin)
    {
        var claims = new[]
        {
            new Claim(ClaimTypes.NameIdentifier, admin.AdminId.ToString()),
            new Claim(ClaimTypes.Name, admin.FullName),
            new Claim("EmpId", admin.EmpId),
            new Claim("Source", "ADMIN"),
            new Claim(ClaimTypes.Role, admin.Role.Role)
        };

        return BuildToken(claims);
    }

    // ── Shared token builder ──────────────────────────────────────────────
    private string BuildToken(Claim[] claims)
    {
        var key = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]!));

        var creds = new SigningCredentials(
            key,
            SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: _configuration["Jwt:Issuer"],
            audience: _configuration["Jwt:Audience"],
            claims: claims,
            expires: DateTime.Now.AddMinutes(
                Convert.ToDouble(_configuration["Jwt:ExpiryMinutes"])),
            signingCredentials: creds);

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}