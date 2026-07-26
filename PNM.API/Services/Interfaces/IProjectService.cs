using PNM.Core.DTO.Project;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface IProjectService
    {
        Task<List<ProjectResponse>> GetAllAsync();

        Task<ProjectResponse?> GetByIdAsync(int projId);

        Task<ProjectResponse> SaveAsync(ProjectRequest request);

        Task<ProjectResponse?> UpdateAsync(int projId, ProjectRequest request);

        Task<ProjectResponse?> DeleteAsync(int projId);
    }
}
