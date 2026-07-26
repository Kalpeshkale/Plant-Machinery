using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.ProjOpAllocation;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;

namespace PNM.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class ProjOpAllocationController : ControllerBase
    {
        private readonly IProjOpAllocationService _projOpAllocationService;

        public ProjOpAllocationController(IProjOpAllocationService projOpAllocationService)
        {
            _projOpAllocationService = projOpAllocationService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _projOpAllocationService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(
                data, "Project operator allocation list retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _projOpAllocationService.GetByIdAsync(id);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("Project operator allocation not found."));
            return Ok(ApiResponseHelper.Success(
                data, "Project operator allocation details retrieved successfully."));

        }

        [HttpPost]
        public async Task<IActionResult> Save(ProjOpAllocationRequest request)
        {
            var result = await _projOpAllocationService.SaveAsync(request);

            return Ok(ApiResponseHelper.Success(
                result,
                "Project operator allocation saved successfully."
            ));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, ProjOpAllocationRequest request)
        {
            var result = await _projOpAllocationService.UpdateAsync(id, request);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Project operator allocation not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Project operator allocation updated successfully."
            ));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _projOpAllocationService.DeleteAsync(id);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Project operator allocation not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Project operator allocation deleted successfully."
            ));
        }
    }
}
