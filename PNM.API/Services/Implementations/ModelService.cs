using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.Model;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;

namespace PNM.Service.Services.Implementations;

public class ModelService : IModelService
{
    private readonly PnmDbContext _context;

    public ModelService(PnmDbContext context)
    {
        _context = context;
    }

    public async Task<List<ModelResponse>> GetAllAsync()
    {
        return await _context.MstModels
            .Include(x => x.Make)
            .Where(x => x.IsActive)
            .OrderBy(x => x.ModelNo)
            .Select(x => new ModelResponse
            {
                ModelId = x.ModelId,
                MakeId = x.MakeId,
                MakeName = x.Make.MakeName,
                ModelNo = x.ModelNo
            })
            .ToListAsync();
    }

    public async Task<ModelResponse?> GetByIdAsync(int modelId)
    {
        return await _context.MstModels
            .Include(x => x.Make)
            .Where(x => x.ModelId == modelId && x.IsActive)
            .Select(x => new ModelResponse
            {
                ModelId = x.ModelId,
                MakeId = x.MakeId,
                MakeName = x.Make.MakeName,
                ModelNo = x.ModelNo
            })
            .FirstOrDefaultAsync();
    }

    public async Task<ModelResponse> SaveAsync(ModelRequest request)
    {
        request.ModelNo = request.ModelNo.Trim();

        bool exists = await _context.MstModels
            .AnyAsync(x => x.IsActive &&
                           x.MakeId == request.MakeId &&
                           x.ModelNo.ToLower() == request.ModelNo.ToLower());

        if (exists)
            throw new Exception("Model already exists.");

        var entity = new MstModel
        {
            UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
            MakeId = request.MakeId,
            ModelNo = request.ModelNo,
            IsActive = true,
            CreatedBy = 0,
            CreatedOn = DateTime.Now
            // CreatedBy will be added after CurrentUserService
        };

        _context.MstModels.Add(entity);
        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.ModelId) ?? new ModelResponse
        {
            ModelId = entity.ModelId,
            MakeId = entity.MakeId,
            ModelNo = entity.ModelNo
        };
    }

    public async Task<ModelResponse?> UpdateAsync(int modelId, ModelRequest request)
    {
        var entity = await _context.MstModels
            .FirstOrDefaultAsync(x => x.ModelId == modelId && x.IsActive);

        if (entity == null)
            return null;

        request.ModelNo = request.ModelNo.Trim();

        bool exists = await _context.MstModels
            .AnyAsync(x => x.ModelId != modelId &&
                           x.IsActive &&
                           x.MakeId == request.MakeId &&
                           x.ModelNo.ToLower() == request.ModelNo.ToLower());

        if (exists)
            throw new Exception("Model already exists.");

        entity.MakeId = request.MakeId;
        entity.ModelNo = request.ModelNo;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.ModelId);
    }

    public async Task<ModelResponse?> DeleteAsync(int modelId)
    {
        var entity = await _context.MstModels
            .FirstOrDefaultAsync(x => x.ModelId == modelId && x.IsActive);

        if (entity == null)
            return null;

        entity.IsActive = false;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return new ModelResponse
        {
            ModelId = entity.ModelId,
            MakeId = entity.MakeId,
            ModelNo = entity.ModelNo
        };
    }
}
