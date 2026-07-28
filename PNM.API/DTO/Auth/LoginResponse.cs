namespace PNM.Core.DTO.Auth
{
    public class LoginResponse
    {
        public int UserId { get; set; }

        public string UserName { get; set; } = string.Empty;

        public int DeptId { get; set; }

        public int RoleId { get; set; }

        public string RoleName { get; set; } = string.Empty;

        /// <summary>"ADMIN" = from tbl_Admin | "OPERATOR" = from tbl_User</summary>
        public string UserSource { get; set; } = string.Empty;

        public string Token { get; set; } = string.Empty;
    }
}