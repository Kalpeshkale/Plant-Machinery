using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.Project;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;

namespace PNM.Service.Services.Implementations;

public class ProjectService : IProjectService
{
    private readonly PnmDbContext _context;
    private readonly ICurrentUserService _currentUserService;

    public ProjectService(PnmDbContext context, ICurrentUserService currentUserService)
    {
        _context = context;
        _currentUserService = currentUserService;
    }

    public async Task<List<ProjectResponse>> GetAllAsync()
    {
        return await _context.TblProjects
            .Include(x => x.Dept)
            .Include(x => x.SiteInCharge)
            .Include(x => x.ProjectManager)
            .Where(x => x.IsActive)
            .OrderBy(x => x.ProjName)
            .Select(x => new ProjectResponse
            {
                ProjId = x.ProjId,
                DeptId = x.DeptId,
                DeptName = x.Dept.DeptName,
                ProjCode = x.ProjCode,
                ProjName = x.ProjName,
                ClientName = x.ClientName,
                Location = x.Location,
                SiteInChargeId = x.SiteInChargeId,
                SiteInChargeName = x.SiteInCharge != null ? x.SiteInCharge.UserName : null,
                ProjectManagerId = x.ProjectManagerId,
                ProjectManagerName = x.ProjectManager != null ? x.ProjectManager.UserName : null,
                StartDate = x.StartDate,
                EndDate = x.EndDate,
                ProjStatus = x.ProjStatus
            })
            .ToListAsync();
    }

    public async Task<ProjectResponse?> GetByIdAsync(int projId)
    {
        return await _context.TblProjects
            .Include(x => x.Dept)
            .Include(x => x.SiteInCharge)
            .Include(x => x.ProjectManager)
            .Where(x => x.ProjId == projId && x.IsActive)
            .Select(x => new ProjectResponse
            {
                ProjId = x.ProjId,
                DeptId = x.DeptId,
                DeptName = x.Dept.DeptName,
                ProjCode = x.ProjCode,
                ProjName = x.ProjName,
                ClientName = x.ClientName,
                Location = x.Location,
                SiteInChargeId = x.SiteInChargeId,
                SiteInChargeName = x.SiteInCharge != null ? x.SiteInCharge.UserName : null,
                ProjectManagerId = x.ProjectManagerId,
                ProjectManagerName = x.ProjectManager != null ? x.ProjectManager.UserName : null,
                StartDate = x.StartDate,
                EndDate = x.EndDate,
                ProjStatus = x.ProjStatus
            })
            .FirstOrDefaultAsync();
    }

    public async Task<ProjectResponse> SaveAsync(ProjectRequest request)
    {
        request.ProjCode = request.ProjCode.Trim();
        request.ProjName = request.ProjName.Trim();

        bool exists = await _context.TblProjects
            .AnyAsync(x => x.IsActive &&
                           x.ProjCode.ToLower() == request.ProjCode.ToLower());

        if (exists)
            throw new Exception("Project already exists.");

        var entity = new TblProject
        {
            UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
            DeptId = request.DeptId,
            ProjCode = request.ProjCode,
            ProjName = request.ProjName,
            ClientName = request.ClientName,
            Location = request.Location,
            SiteInChargeId = request.SiteInChargeId,
            ProjectManagerId = request.ProjectManagerId,
            StartDate = request.StartDate,
            EndDate = request.EndDate,
            ProjStatus = request.ProjStatus,
            IsActive = true,
            CreatedBy = _currentUserService.UserId ?? 4,
            CreatedOn = DateTime.Now
        };

        _context.TblProjects.Add(entity);
        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.ProjId) ?? new ProjectResponse
        {
            ProjId = entity.ProjId,
            DeptId = entity.DeptId,
            ProjCode = entity.ProjCode,
            ProjName = entity.ProjName,
            ClientName = entity.ClientName,
            Location = entity.Location,
            SiteInChargeId = entity.SiteInChargeId,
            ProjectManagerId = entity.ProjectManagerId,
            StartDate = entity.StartDate,
            EndDate = entity.EndDate,
            ProjStatus = entity.ProjStatus
        };
    }

    public async Task<ProjectResponse?> UpdateAsync(int projId, ProjectRequest request)
    {
        var entity = await _context.TblProjects
            .FirstOrDefaultAsync(x => x.ProjId == projId && x.IsActive);

        if (entity == null)
            return null;

        request.ProjCode = request.ProjCode.Trim();
        request.ProjName = request.ProjName.Trim();

        bool exists = await _context.TblProjects
            .AnyAsync(x => x.ProjId != projId &&
                           x.IsActive &&
                           x.ProjCode.ToLower() == request.ProjCode.ToLower());

        if (exists)
            throw new Exception("Project already exists.");

        entity.DeptId = request.DeptId;
        entity.ProjCode = request.ProjCode;
        entity.ProjName = request.ProjName;
        entity.ClientName = request.ClientName;
        entity.Location = request.Location;
        entity.SiteInChargeId = request.SiteInChargeId;
        entity.ProjectManagerId = request.ProjectManagerId;
        entity.StartDate = request.StartDate;
        entity.EndDate = request.EndDate;
        entity.ProjStatus = request.ProjStatus;
        entity.ModifiedBy = _currentUserService.UserId ?? 4;
        entity.ModifiedOn = DateTime.Now;

        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.ProjId);
    }

    public async Task<ProjectResponse?> DeleteAsync(int projId)
    {
        var entity = await _context.TblProjects
            .FirstOrDefaultAsync(x => x.ProjId == projId && x.IsActive);

        if (entity == null)
            return null;

        entity.IsActive = false;
        entity.ModifiedBy = _currentUserService.UserId ?? 4;
        entity.ModifiedOn = DateTime.Now;

        await _context.SaveChangesAsync();

        return new ProjectResponse
        {
            ProjId = entity.ProjId,
            DeptId = entity.DeptId,
            ProjCode = entity.ProjCode,
            ProjName = entity.ProjName,
            ClientName = entity.ClientName,
            Location = entity.Location,
            SiteInChargeId = entity.SiteInChargeId,
            ProjectManagerId = entity.ProjectManagerId,
            StartDate = entity.StartDate,
            EndDate = entity.EndDate,
            ProjStatus = entity.ProjStatus
        };
    }
}
