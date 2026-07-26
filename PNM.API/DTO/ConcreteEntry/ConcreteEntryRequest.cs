using System;

namespace PNM.Core.DTO.ConcreteEntry
{
    public class ConcreteEntryRequest
    {
        public string InfoProviderEmployeeId { get; set; } = null!;
        public string CustomerId { get; set; } = null!;
        public string SiteId { get; set; } = null!;
        public string PlantId { get; set; } = null!;
        public DateTime StartDateTime { get; set; }
        public DateTime StopDateTime { get; set; }
        public int? BreakdownHours { get; set; }
        public int? BreakdownMinutes { get; set; }
        public decimal? Volume { get; set; }
        public decimal? DieselReceived { get; set; }
        public decimal? DieselRate { get; set; }
        public decimal? CementReceivedKg { get; set; }
        public decimal? Hmr { get; set; }
        public decimal? MixerHmr { get; set; }
        public string? ConcreteType { get; set; }
        public string? PourLocation { get; set; }
        public string? InChargeCustomer { get; set; }
        public string? InChargeRohan { get; set; }
        public string? NoteText { get; set; }
    }
}
