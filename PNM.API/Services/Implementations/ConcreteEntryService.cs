using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.ConcreteEntry;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PNM.Service.Services.Implementations
{
    public class ConcreteEntryService : IConcreteEntryService
    {
        private readonly PnmDbContext _context;

        public ConcreteEntryService(PnmDbContext context)
        {
            _context = context;
        }

        public async Task<List<ConcreteEntryResponse>> GetAllAsync()
        {
            return await _context.TrnConcreteEntries
                .Where(x => x.IsActive)
                .Select(x => new ConcreteEntryResponse
                {
                    Id = x.Id,
                    UniqueId = x.UniqueId,
                    InfoProviderEmployeeId = x.InfoProviderEmployeeId,
                    CustomerId = x.CustomerId,
                    SiteId = x.SiteId,
                    PlantId = x.PlantId,
                    StartDateTime = x.StartDateTime,
                    StopDateTime = x.StopDateTime,
                    BreakdownHours = x.BreakdownHours,
                    BreakdownMinutes = x.BreakdownMinutes,
                    Volume = x.Volume,
                    DieselReceived = x.DieselReceived,
                    DieselRate = x.DieselRate,
                    CementReceivedKg = x.CementReceivedKg,
                    Hmr = x.Hmr,
                    MixerHmr = x.MixerHmr,
                    ConcreteType = x.ConcreteType,
                    PourLocation = x.PourLocation,
                    InChargeCustomer = x.InChargeCustomer,
                    InChargeRohan = x.InChargeRohan,
                    NoteText = x.NoteText,
                    CreatedBy = x.CreatedBy,
                    CreatedUserName = x.CreatedUserName,
                    CreatedDate = x.CreatedDate
                })
                .ToListAsync();
        }

        public async Task<ConcreteEntryResponse?> GetByIdAsync(int id)
        {
            var x = await _context.TrnConcreteEntries
                .FirstOrDefaultAsync(y => y.Id == id && y.IsActive);

            if (x == null)
                return null;

            return new ConcreteEntryResponse
            {
                Id = x.Id,
                UniqueId = x.UniqueId,
                InfoProviderEmployeeId = x.InfoProviderEmployeeId,
                CustomerId = x.CustomerId,
                SiteId = x.SiteId,
                PlantId = x.PlantId,
                StartDateTime = x.StartDateTime,
                StopDateTime = x.StopDateTime,
                BreakdownHours = x.BreakdownHours,
                BreakdownMinutes = x.BreakdownMinutes,
                Volume = x.Volume,
                DieselReceived = x.DieselReceived,
                DieselRate = x.DieselRate,
                CementReceivedKg = x.CementReceivedKg,
                Hmr = x.Hmr,
                MixerHmr = x.MixerHmr,
                ConcreteType = x.ConcreteType,
                PourLocation = x.PourLocation,
                InChargeCustomer = x.InChargeCustomer,
                InChargeRohan = x.InChargeRohan,
                NoteText = x.NoteText,
                CreatedBy = x.CreatedBy,
                CreatedUserName = x.CreatedUserName,
                CreatedDate = x.CreatedDate
            };
        }

        public async Task<ConcreteEntryResponse> SaveAsync(ConcreteEntryRequest request)
        {
            var entity = new TrnConcreteEntry
            {
                UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
                InfoProviderEmployeeId = request.InfoProviderEmployeeId,
                CustomerId = request.CustomerId,
                SiteId = request.SiteId,
                PlantId = request.PlantId,
                StartDateTime = request.StartDateTime,
                StopDateTime = request.StopDateTime,
                BreakdownHours = request.BreakdownHours,
                BreakdownMinutes = request.BreakdownMinutes,
                Volume = request.Volume,
                DieselReceived = request.DieselReceived,
                DieselRate = request.DieselRate,
                CementReceivedKg = request.CementReceivedKg,
                Hmr = request.Hmr,
                MixerHmr = request.MixerHmr,
                ConcreteType = request.ConcreteType,
                PourLocation = request.PourLocation,
                InChargeCustomer = request.InChargeCustomer,
                InChargeRohan = request.InChargeRohan,
                NoteText = request.NoteText,
                CreatedBy = request.InfoProviderEmployeeId,
                CreatedUserName = "",
                CreatedDate = DateTime.Now,
                IsActive = true
            };

            _context.TrnConcreteEntries.Add(entity);
            await _context.SaveChangesAsync();

            return await GetByIdAsync(entity.Id) ?? throw new Exception("Failed to retrieve saved concrete production entry.");
        }

        public async Task<ConcreteEntryResponse?> UpdateAsync(int id, ConcreteEntryRequest request)
        {
            var entity = await _context.TrnConcreteEntries
                .FirstOrDefaultAsync(y => y.Id == id && y.IsActive);

            if (entity == null)
                return null;

            entity.InfoProviderEmployeeId = request.InfoProviderEmployeeId;
            entity.CustomerId = request.CustomerId;
            entity.SiteId = request.SiteId;
            entity.PlantId = request.PlantId;
            entity.StartDateTime = request.StartDateTime;
            entity.StopDateTime = request.StopDateTime;
            entity.BreakdownHours = request.BreakdownHours;
            entity.BreakdownMinutes = request.BreakdownMinutes;
            entity.Volume = request.Volume;
            entity.DieselReceived = request.DieselReceived;
            entity.DieselRate = request.DieselRate;
            entity.CementReceivedKg = request.CementReceivedKg;
            entity.Hmr = request.Hmr;
            entity.MixerHmr = request.MixerHmr;
            entity.ConcreteType = request.ConcreteType;
            entity.PourLocation = request.PourLocation;
            entity.InChargeCustomer = request.InChargeCustomer;
            entity.InChargeRohan = request.InChargeRohan;
            entity.NoteText = request.NoteText;
            entity.ModifiedBy = request.InfoProviderEmployeeId;
            entity.ModifiedDate = DateTime.Now;

            await _context.SaveChangesAsync();

            return await GetByIdAsync(id);
        }

        public async Task<ConcreteEntryResponse?> DeleteAsync(int id)
        {
            var entity = await _context.TrnConcreteEntries
                .FirstOrDefaultAsync(y => y.Id == id && y.IsActive);

            if (entity == null)
                return null;

            entity.IsActive = false;
            entity.ModifiedDate = DateTime.Now;

            await _context.SaveChangesAsync();

            return await GetByIdAsync(id) ?? new ConcreteEntryResponse { Id = id };
        }
    }
}
