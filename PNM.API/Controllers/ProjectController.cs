using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.Project;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;

namespace PNM.API.Controllers
{
    //[Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class ProjectController : ControllerBase
    {
        private readonly IProjectService _projectService;

        public ProjectController(IProjectService projectService)
        {
            _projectService = projectService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _projectService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(
                data, "Project list retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _projectService.GetByIdAsync(id);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("Project not found."));
            return Ok(ApiResponseHelper.Success(
                data, "Project details retrieved successfully."));

        }

        [HttpPost]
        public async Task<IActionResult> Save(ProjectRequest request)
        {
            var result = await _projectService.SaveAsync(request);

            return Ok(ApiResponseHelper.Success(
                result,
                "Project saved successfully."
            ));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, ProjectRequest request)
        {
            var result = await _projectService.UpdateAsync(id, request);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Project not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Project updated successfully."
            ));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _projectService.DeleteAsync(id);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Project not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Project deleted successfully."
            ));
        }
    }
}
