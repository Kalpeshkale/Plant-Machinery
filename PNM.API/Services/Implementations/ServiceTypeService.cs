using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.ServiceType;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;

namespace PNM.Service.Services.Implementations;

public class ServiceTypeService : IServiceTypeService
{
    private readonly PnmDbContext _context;

    public ServiceTypeService(PnmDbContext context)
    {
        _context = context;
    }

    public async Task<List<ServiceTypeResponse>> GetAllAsync()
    {
        return await _context.MstServiceTypes
            .Where(x => x.IsActive)
            .OrderBy(x => x.ServTypeName)
            .Select(x => new ServiceTypeResponse
            {
                ServTypeId = x.ServTypeId,
                ServiAreaId = x.ServiAreaId,
                ServTypeName = x.ServTypeName,
                ApproximateCost = x.ApproximateCost
            })
            .ToListAsync();
    }

    public async Task<ServiceTypeResponse?> GetByIdAsync(int servTypeId)
    {
        return await _context.MstServiceTypes
            .Where(x => x.ServTypeId == servTypeId && x.IsActive)
            .Select(x => new ServiceTypeResponse
            {
                ServTypeId = x.ServTypeId,
                ServiAreaId = x.ServiAreaId,
                ServTypeName = x.ServTypeName,
                ApproximateCost = x.ApproximateCost
            })
            .FirstOrDefaultAsync();
    }

    public async Task<ServiceTypeResponse> SaveAsync(ServiceTypeRequest request)
    {
        request.ServTypeName = request.ServTypeName.Trim();

        bool idExists = await _context.MstServiceTypes
            .AnyAsync(x => x.ServTypeId == request.ServTypeId);

        if (idExists)
            throw new Exception("Service type ID already exists.");

        bool nameExists = await _context.MstServiceTypes
            .AnyAsync(x => x.IsActive &&
                           x.ServTypeName.ToLower() == request.ServTypeName.ToLower());

        if (nameExists)
            throw new Exception("Service type already exists.");

        var entity = new MstServiceType
        {
            ServTypeId = request.ServTypeId,
            UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
            ServiAreaId = request.ServiAreaId,
            ServTypeName = request.ServTypeName,
            ApproximateCost = request.ApproximateCost,
            IsActive = true,
            CreatedBy = 0,
            CreatedOn = DateTime.Now
            // CreatedBy will be added after CurrentUserService
        };

        _context.MstServiceTypes.Add(entity);
        await _context.SaveChangesAsync();

        return new ServiceTypeResponse
        {
            ServTypeId = entity.ServTypeId,
            ServiAreaId = entity.ServiAreaId,
            ServTypeName = entity.ServTypeName,
            ApproximateCost = entity.ApproximateCost
        };
    }

    public async Task<ServiceTypeResponse?> UpdateAsync(int servTypeId, ServiceTypeRequest request)
    {
        var entity = await _context.MstServiceTypes
            .FirstOrDefaultAsync(x => x.ServTypeId == servTypeId && x.IsActive);

        if (entity == null)
            return null;

        request.ServTypeName = request.ServTypeName.Trim();

        bool exists = await _context.MstServiceTypes
            .AnyAsync(x => x.ServTypeId != servTypeId &&
                           x.IsActive &&
                           x.ServTypeName.ToLower() == request.ServTypeName.ToLower());

        if (exists)
            throw new Exception("Service type already exists.");

        entity.ServiAreaId = request.ServiAreaId;
        entity.ServTypeName = request.ServTypeName;
        entity.ApproximateCost = request.ApproximateCost;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return new ServiceTypeResponse
        {
            ServTypeId = entity.ServTypeId,
            ServiAreaId = entity.ServiAreaId,
            ServTypeName = entity.ServTypeName,
            ApproximateCost = entity.ApproximateCost
        };
    }

    public async Task<ServiceTypeResponse?> DeleteAsync(int servTypeId)
    {
        var entity = await _context.MstServiceTypes
            .FirstOrDefaultAsync(x => x.ServTypeId == servTypeId && x.IsActive);

        if (entity == null)
            return null;

        entity.IsActive = false;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return new ServiceTypeResponse
        {
            ServTypeId = entity.ServTypeId,
            ServiAreaId = entity.ServiAreaId,
            ServTypeName = entity.ServTypeName,
            ApproximateCost = entity.ApproximateCost
        };
    }
}
