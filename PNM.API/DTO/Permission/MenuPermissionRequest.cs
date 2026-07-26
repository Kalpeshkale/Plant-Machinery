using System.ComponentModel.DataAnnotations;

namespace PNM.Core.DTO.Permission
{
    public class MenuPermissionRequest
    {
        [Required]
        [StringLength(50)]
        public string PerKey { get; set; } = null!;

        [Required]
        [StringLength(100)]
        public string MenuName { get; set; } = null!;

        public int SortOrder { get; set; }

        [StringLength(100)]
        public string? ParentKey { get; set; }

        [StringLength(20)]
        public string? MenuType { get; set; }

        [StringLength(100)]
        public string? ViewName { get; set; }

        [StringLength(100)]
        public string? IconClass { get; set; }

        public bool IsVisible { get; set; }
    }
}
