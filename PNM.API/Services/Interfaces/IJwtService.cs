using PNM.Infrastructure.Entities;

namespace PNM.Service.Services.Interfaces
{
    public interface IJwtService
    {
        /// <summary>Generate JWT for an Operator (tbl_User).</summary>
        string GenerateToken(TblUser user);

        /// <summary>Generate JWT for an Admin/SIC (tbl_Admin).</summary>
        string GenerateToken(TblAdmin admin);
    }
}