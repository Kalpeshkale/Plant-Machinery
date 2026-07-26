using PNM.Infrastructure.Entities;

namespace PNM.Service.Services.Interfaces;

public interface IJwtService
{
    string GenerateToken(TblUser user);
}