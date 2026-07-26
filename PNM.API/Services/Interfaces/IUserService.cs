using PNM.Core.DTO.User;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface IUserService
    {
        Task<List<UserResponse>> GetAllAsync();

        Task<UserResponse?> GetByIdAsync(int userId);

        Task<UserResponse> SaveAsync(UserRequest request);

        Task<UserResponse?> UpdateAsync(int userId, UserRequest request);

        Task<UserResponse?> DeleteAsync(int userId);
    }
}
