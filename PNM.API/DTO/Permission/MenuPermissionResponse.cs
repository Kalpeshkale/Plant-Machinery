namespace PNM.Core.DTO.Permission
{
    public class MenuPermissionResponse
    {
        public int Id { get; set; }
        public string? UniqueId { get; set; }
        public string PerKey { get; set; } = null!;
        public string MenuName { get; set; } = null!;
        public int SortOrder { get; set; }
        public string? ParentKey { get; set; }
        public string? MenuType { get; set; }
        public string? ViewName { get; set; }
        public string? IconClass { get; set; }
        public bool IsVisible { get; set; }
    }
}
