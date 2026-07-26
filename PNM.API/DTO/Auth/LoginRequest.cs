namespace PNM.Core.DTO.Auth
{
    public class LoginRequest
    {
        public string EmpId { get; set; } = string.Empty;

        public string Password { get; set; } = string.Empty;
    }
}