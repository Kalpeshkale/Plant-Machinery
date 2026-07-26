using PNM.Core.DTO.Category;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface ICategoryService
    {
        Task<List<CategoryResponse>> GetAllAsync();

        Task<CategoryResponse?> GetByIdAsync(int catId);

        Task<CategoryResponse> SaveAsync(CategoryRequest request);

        Task<CategoryResponse?> UpdateAsync(int catId, CategoryRequest request);

        Task<CategoryResponse?> DeleteAsync(int catId);
    }
}
