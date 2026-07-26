using PNM.Core.DTO.ConcreteEntry;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface IConcreteEntryService
    {
        Task<List<ConcreteEntryResponse>> GetAllAsync();
        Task<ConcreteEntryResponse?> GetByIdAsync(int id);
        Task<ConcreteEntryResponse> SaveAsync(ConcreteEntryRequest request);
        Task<ConcreteEntryResponse?> UpdateAsync(int id, ConcreteEntryRequest request);
        Task<ConcreteEntryResponse?> DeleteAsync(int id);
    }
}
