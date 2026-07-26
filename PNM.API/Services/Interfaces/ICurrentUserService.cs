namespace PNM.Service.Services.Interfaces
{
    public interface ICurrentUserService
    {
        int? UserId { get; }
        string? UserName { get; }
        string? EmpId { get; }
        string? Role { get; }
    }
}
