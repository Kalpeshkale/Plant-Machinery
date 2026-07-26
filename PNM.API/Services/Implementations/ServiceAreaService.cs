using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.ServiceArea;
using PNM.Infrastructure.Context;
using PNM.Service.Services.Interfaces;

namespace PNM.Service.Services.Implementations;

public class ServiceAreaService : IServiceAreaService
{
    private readonly PnmDbContext _context;

    public ServiceAreaService(PnmDbContext context)
    {
        _context = context;
    }

    public async Task<List<ServiceAreaResponse>> GetAllAsync()
    {
        return await (
            from x in _context.MstServiceAreas
            join m in _context.MstModels on x.ModelId equals m.ModelId into modelJoin
            from m in modelJoin.DefaultIfEmpty()
            where x.IsActive
            orderby x.ServAreaId
            select new ServiceAreaResponse
            {
                ServAreaId = x.ServAreaId,
                ModelId = x.ModelId,
                ModelNo = m != null ? m.ModelNo : null,
                ServAreaName = x.ServAreaName,
                IsCheckType = x.IsCheckType,
                Priority = x.Priority
            })
            .ToListAsync();
    }

    public async Task<ServiceAreaResponse?> GetByIdAsync(int servAreaId)
    {
        return await (
            from x in _context.MstServiceAreas
            join m in _context.MstModels on x.ModelId equals m.ModelId into modelJoin
            from m in modelJoin.DefaultIfEmpty()
            where x.ServAreaId == servAreaId && x.IsActive
            select new ServiceAreaResponse
            {
                ServAreaId = x.ServAreaId,
                ModelId = x.ModelId,
                ModelNo = m != null ? m.ModelNo : null,
                ServAreaName = x.ServAreaName,
                IsCheckType = x.IsCheckType,
                Priority = x.Priority
            })
            .FirstOrDefaultAsync();
    }

    public async Task<ServiceAreaResponse> SaveAsync(ServiceAreaRequest request)
    {
        var uniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper();

        await _context.Database.ExecuteSqlInterpolatedAsync($@"
            INSERT INTO mst_ServiceArea
                (UniqueId, ModelId, ServAreaName, IsCheckType, Priority, IsActive, CreatedBy, CreatedOn)
            VALUES
                ({uniqueId}, {request.ModelId}, {request.ServAreaName}, {request.IsCheckType}, {request.Priority}, 1, 0, {DateTime.Now})");

        var entity = await (
            from x in _context.MstServiceAreas
            where x.UniqueId == uniqueId
            select x)
            .FirstOrDefaultAsync();

        return entity == null
            ? new ServiceAreaResponse
            {
                ModelId = request.ModelId,
                ServAreaName = request.ServAreaName,
                IsCheckType = request.IsCheckType,
                Priority = request.Priority
            }
            : await GetByIdAsync(entity.ServAreaId) ?? new ServiceAreaResponse
            {
                ServAreaId = entity.ServAreaId,
                ModelId = entity.ModelId,
                ServAreaName = entity.ServAreaName,
                IsCheckType = entity.IsCheckType,
                Priority = entity.Priority
            };
    }

    public async Task<ServiceAreaResponse?> UpdateAsync(int servAreaId, ServiceAreaRequest request)
    {
        var exists = await _context.MstServiceAreas
            .AnyAsync(x => x.ServAreaId == servAreaId && x.IsActive);

        if (!exists)
            return null;

        await _context.MstServiceAreas
            .Where(x => x.ServAreaId == servAreaId && x.IsActive)
            .ExecuteUpdateAsync(setters => setters
                .SetProperty(x => x.ModelId, request.ModelId)
                .SetProperty(x => x.ServAreaName, request.ServAreaName)
                .SetProperty(x => x.IsCheckType, request.IsCheckType)
                .SetProperty(x => x.Priority, request.Priority)
                .SetProperty(x => x.ModifiedOn, DateTime.Now));
        // ModifiedBy will be added after CurrentUserService

        return await GetByIdAsync(servAreaId);
    }

    public async Task<ServiceAreaResponse?> DeleteAsync(int servAreaId)
    {
        var entity = await GetByIdAsync(servAreaId);

        if (entity == null)
            return null;

        await _context.MstServiceAreas
            .Where(x => x.ServAreaId == servAreaId && x.IsActive)
            .ExecuteUpdateAsync(setters => setters
                .SetProperty(x => x.IsActive, false)
                .SetProperty(x => x.ModifiedOn, DateTime.Now));
        // ModifiedBy will be added after CurrentUserService

        return entity;
    }
}
