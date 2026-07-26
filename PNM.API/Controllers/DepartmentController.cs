using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.Department;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;

namespace PNM.API.Controllers
{
    //[Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class DepartmentController : ControllerBase
    {
        private readonly IDepartmentService _departmentService;

        public DepartmentController(IDepartmentService departmentService)
        {
            _departmentService = departmentService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _departmentService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(
                data, "Department list retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _departmentService.GetByIdAsync(id);
            if (data == null)
            return NotFound(ApiResponseHelper.Failure<object>("Department not found."));
            return Ok(ApiResponseHelper.Success(
                data, "Department details retrieved successfully."));

        }

        [HttpPost]
        public async Task<IActionResult> Save(DepartmentRequest request)
        {
            var result = await _departmentService.SaveAsync(request);

            return Ok(ApiResponseHelper.Success(
                result,
                "Department saved successfully."
            ));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, DepartmentRequest request)
        {
            var result = await _departmentService.UpdateAsync(id, request);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Department not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Department updated successfully."
            ));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _departmentService.DeleteAsync(id);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Department not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Department deleted successfully."
            ));
        }
    }
}