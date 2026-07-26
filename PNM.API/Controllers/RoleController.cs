using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.Role;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;

namespace PNM.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class RoleController : ControllerBase
    {
        private readonly IRoleService _roleService;

        public RoleController(IRoleService roleService)
        {
            _roleService = roleService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _roleService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(
                data, "Role list retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _roleService.GetByIdAsync(id);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("Role not found."));
            return Ok(ApiResponseHelper.Success(
                data, "Role details retrieved successfully."));

        }

        [HttpPost]
        public async Task<IActionResult> Save(RoleRequest request)
        {
            var result = await _roleService.SaveAsync(request);

            return Ok(ApiResponseHelper.Success(
                result,
                "Role saved successfully."
            ));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, RoleRequest request)
        {
            var result = await _roleService.UpdateAsync(id, request);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Role not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Role updated successfully."
            ));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _roleService.DeleteAsync(id);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Role not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Role deleted successfully."
            ));
        }
    }
}
