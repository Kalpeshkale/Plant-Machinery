namespace PNM.Core.DTO.Department
{
    public class DepartmentResponse
    {
        public int DeptId { get; set; }

        public string DeptName { get; set; } = string.Empty;
    }

    public class DepartmentRequest
    {
        public string DeptName { get; set; } = string.Empty;
    }
}