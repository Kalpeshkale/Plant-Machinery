namespace PNM.Core.Entities.Common
{
    public abstract class BaseEntity
    {
        public string UniqueId { get; set; } = string.Empty;

        public bool IsActive { get; set; }

        public int CreatedBy { get; set; }

        public DateTime CreatedOn { get; set; }

        public int? ModifiedBy { get; set; }

        public DateTime? ModifiedOn { get; set; }
    }
}