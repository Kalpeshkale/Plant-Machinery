using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.Permission;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;
using System.Threading.Tasks;

namespace PNM.API.Controllers
{
    //[Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class PermissionController : ControllerBase
    {
        private readonly IPermissionService _permissionService;

        public PermissionController(IPermissionService permissionService)
        {
            _permissionService = permissionService;
        }

        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetUserMenuPermissions(int userId)
        {
            var data = await _permissionService.GetUserMenuPermissionsAsync(userId);
            return Ok(ApiResponseHelper.Success(data, "User menu permissions retrieved successfully."));
        }

        [HttpGet("all")]
        public async Task<IActionResult> GetAllMenuPermissions()
        {
            var data = await _permissionService.GetAllMenuPermissionsAsync();
            return Ok(ApiResponseHelper.Success(data, "All menu permissions retrieved successfully."));
        }

        [HttpPost("role-access")]
        public async Task<IActionResult> SaveRoleMenuAccess(RoleMenuAccessRequest request)
        {
            var result = await _permissionService.SaveRoleMenuAccessAsync(request);
            if (!result)
                return BadRequest(ApiResponseHelper.Failure<object>("Failed to save role menu access."));
            return Ok(ApiResponseHelper.Success(result, "Role menu access saved successfully."));
        }

        [HttpPost("employee-access")]
        public async Task<IActionResult> SaveEmployeeMenuAccess(EmployeeMenuAccessRequest request)
        {
            var result = await _permissionService.SaveEmployeeMenuAccessAsync(request);
            if (!result)
                return BadRequest(ApiResponseHelper.Failure<object>("Failed to save employee menu access override."));
            return Ok(ApiResponseHelper.Success(result, "Employee menu access overrides saved successfully."));
        }

        [HttpPost]
        public async Task<IActionResult> SaveMenuPermission(MenuPermissionRequest request)
        {
            var result = await _permissionService.SaveMenuPermissionAsync(request);
            return Ok(ApiResponseHelper.Success(result, "Menu permission saved successfully."));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateMenuPermission(int id, MenuPermissionRequest request)
        {
            var result = await _permissionService.UpdateMenuPermissionAsync(id, request);
            if (result == null)
                return NotFound(ApiResponseHelper.Failure<object>("Menu permission not found."));
            return Ok(ApiResponseHelper.Success(result, "Menu permission updated successfully."));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteMenuPermission(int id)
        {
            var result = await _permissionService.DeleteMenuPermissionAsync(id);
            if (result == null)
                return NotFound(ApiResponseHelper.Failure<object>("Menu permission not found."));
            return Ok(ApiResponseHelper.Success(result, "Menu permission deleted successfully."));
        }
    }
}
