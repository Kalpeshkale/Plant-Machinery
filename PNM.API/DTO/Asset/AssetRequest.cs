using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.Asset
{
    public class AssetRequest
    {
        public int DeptId { get; set; }

        public string AssetCode { get; set; } = string.Empty;

        public string AssetName { get; set; } = string.Empty;

        public int TypeId { get; set; }

        public int SubTypeId { get; set; }

        public int MakeId { get; set; }

        public int ModelId { get; set; }

        public int OwnerId { get; set; }

        public string? RegistrationNo { get; set; }

        public string? ChassisNo { get; set; }

        public string? EngineNo { get; set; }

        public string? SerialNo { get; set; }

        public string? MeterType { get; set; }

        public decimal CurrentMeterReading { get; set; }

        public string? FuelType { get; set; }

        public decimal? FuelTankCapacity { get; set; }

        public DateOnly? PurchaseDate { get; set; }

        public decimal? PurchaseCost { get; set; }

        public string? SupplierName { get; set; }

        public string? InvoiceNo { get; set; }

        public string AssetStatus { get; set; } = string.Empty;

        public string? Remarks { get; set; }
    }
}
