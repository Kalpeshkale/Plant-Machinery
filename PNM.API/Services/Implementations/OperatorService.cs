using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.Operator;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;

namespace PNM.Service.Services.Implementations;

public class OperatorService : IOperatorService
{
    private readonly PnmDbContext _context;
    private readonly ICurrentUserService _currentUserService;

    public OperatorService(PnmDbContext context, ICurrentUserService currentUserService)
    {
        _context = context;
        _currentUserService = currentUserService;
    }

    public async Task<List<OperatorResponse>> GetAllAsync()
    {
        return await _context.TblOperators
            .Where(x => x.IsActive)
            .OrderBy(x => x.FullName)
            .Select(x => new OperatorResponse
            {
                OpId = x.OpId,
                OpCode = x.OpCode,
                OpType = x.OpType,
                FullName = x.FullName,
                DateOfBirth = x.DateOfBirth,
                Gender = x.Gender,
                Mobile = x.Mobile,
                AadhaarNo = x.AadhaarNo,
                LicenseNo = x.LicenseNo,
                Address = x.Address,
                Doj = x.Doj,
                Status = x.Status,
                PhotoPath = x.PhotoPath
            })
            .ToListAsync();
    }

    public async Task<OperatorResponse?> GetByIdAsync(int opId)
    {
        return await _context.TblOperators
            .Where(x => x.OpId == opId && x.IsActive)
            .Select(x => new OperatorResponse
            {
                OpId = x.OpId,
                OpCode = x.OpCode,
                OpType = x.OpType,
                FullName = x.FullName,
                DateOfBirth = x.DateOfBirth,
                Gender = x.Gender,
                Mobile = x.Mobile,
                AadhaarNo = x.AadhaarNo,
                LicenseNo = x.LicenseNo,
                Address = x.Address,
                Doj = x.Doj,
                Status = x.Status,
                PhotoPath = x.PhotoPath
            })
            .FirstOrDefaultAsync();
    }

    public async Task<OperatorResponse> SaveAsync(OperatorRequest request)
    {
        request.OpCode = request.OpCode.Trim();
        request.FullName = request.FullName.Trim();

        bool exists = await _context.TblOperators
            .AnyAsync(x => x.IsActive &&
                           x.OpCode.ToLower() == request.OpCode.ToLower());

        if (exists)
            throw new Exception("Operator already exists.");

        var entity = new TblOperator
        {
            UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
            OpCode = request.OpCode,
            OpType = request.OpType,
            FullName = request.FullName,
            DateOfBirth = request.DateOfBirth,
            Gender = request.Gender,
            Mobile = request.Mobile,
            AadhaarNo = request.AadhaarNo,
            LicenseNo = request.LicenseNo,
            Address = request.Address,
            Doj = request.Doj,
            Status = request.Status ?? "Active",
            PhotoPath = request.PhotoPath,
            IsActive = true,
            CreatedBy = _currentUserService.UserId ?? 4,
            CreatedOn = DateTime.Now
        };

        _context.TblOperators.Add(entity);
        await _context.SaveChangesAsync();

        return new OperatorResponse
        {
            OpId = entity.OpId,
            OpCode = entity.OpCode,
            OpType = entity.OpType,
            FullName = entity.FullName,
            DateOfBirth = entity.DateOfBirth,
            Gender = entity.Gender,
            Mobile = entity.Mobile,
            AadhaarNo = entity.AadhaarNo,
            LicenseNo = entity.LicenseNo,
            Address = entity.Address,
            Doj = entity.Doj,
            Status = entity.Status,
            PhotoPath = entity.PhotoPath
        };
    }

    public async Task<OperatorResponse?> UpdateAsync(int opId, OperatorRequest request)
    {
        var entity = await _context.TblOperators
            .FirstOrDefaultAsync(x => x.OpId == opId && x.IsActive);

        if (entity == null)
            return null;

        request.OpCode = request.OpCode.Trim();
        request.FullName = request.FullName.Trim();

        bool exists = await _context.TblOperators
            .AnyAsync(x => x.OpId != opId &&
                           x.IsActive &&
                           x.OpCode.ToLower() == request.OpCode.ToLower());

        if (exists)
            throw new Exception("Operator already exists.");

        entity.OpCode = request.OpCode;
        entity.OpType = request.OpType;
        entity.FullName = request.FullName;
        entity.DateOfBirth = request.DateOfBirth;
        entity.Gender = request.Gender;
        entity.Mobile = request.Mobile;
        entity.AadhaarNo = request.AadhaarNo;
        entity.LicenseNo = request.LicenseNo;
        entity.Address = request.Address;
        entity.Doj = request.Doj;
        entity.Status = request.Status ?? entity.Status;
        entity.PhotoPath = request.PhotoPath;
        entity.ModifiedOn = DateTime.Now;
        entity.ModifiedBy = null; // set properly once auth is wired up

        await _context.SaveChangesAsync();

        return new OperatorResponse
        {
            OpId = entity.OpId,
            OpCode = entity.OpCode,
            OpType = entity.OpType,
            FullName = entity.FullName,
            DateOfBirth = entity.DateOfBirth,
            Gender = entity.Gender,
            Mobile = entity.Mobile,
            AadhaarNo = entity.AadhaarNo,
            LicenseNo = entity.LicenseNo,
            Address = entity.Address,
            Doj = entity.Doj,
            Status = entity.Status,
            PhotoPath = entity.PhotoPath
        };
    }

    public async Task<OperatorResponse?> DeleteAsync(int opId)
    {
        var entity = await _context.TblOperators
            .FirstOrDefaultAsync(x => x.OpId == opId && x.IsActive);

        if (entity == null)
            return null;

        entity.IsActive = false;
        entity.ModifiedOn = DateTime.Now;
        entity.ModifiedBy = null; // set properly once auth is wired up

        await _context.SaveChangesAsync();

        return new OperatorResponse
        {
            OpId = entity.OpId,
            OpCode = entity.OpCode,
            OpType = entity.OpType,
            FullName = entity.FullName,
            DateOfBirth = entity.DateOfBirth,
            Gender = entity.Gender,
            Mobile = entity.Mobile,
            AadhaarNo = entity.AadhaarNo,
            LicenseNo = entity.LicenseNo,
            Address = entity.Address,
            Doj = entity.Doj,
            Status = entity.Status,
            PhotoPath = entity.PhotoPath
        };
    }
}
