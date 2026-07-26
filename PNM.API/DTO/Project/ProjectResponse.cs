using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.Project
{
    public class ProjectResponse
    {
        public int ProjId { get; set; }

        public int DeptId { get; set; }

        public string? DeptName { get; set; }

        public string ProjCode { get; set; } = string.Empty;

        public string ProjName { get; set; } = string.Empty;

        public string? ClientName { get; set; }

        public string Location { get; set; } = string.Empty;

        public int? SiteInChargeId { get; set; }

        public string? SiteInChargeName { get; set; }

        public int? ProjectManagerId { get; set; }

        public string? ProjectManagerName { get; set; }

        public DateOnly? StartDate { get; set; }

        public DateOnly? EndDate { get; set; }

        public string ProjStatus { get; set; } = string.Empty;
    }
}
