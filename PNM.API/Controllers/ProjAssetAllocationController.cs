using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.ProjAssetAllocation;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;

namespace PNM.API.Controllers
{
    [AllowAnonymous]
    [ApiController]
    [Route("api/[controller]")]
    public class ProjAssetAllocationController : ControllerBase
    {
        private readonly IProjAssetAllocationService _projAssetAllocationService;

        public ProjAssetAllocationController(IProjAssetAllocationService projAssetAllocationService)
        {
            _projAssetAllocationService = projAssetAllocationService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _projAssetAllocationService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(
                data, "Project asset allocation list retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _projAssetAllocationService.GetByIdAsync(id);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("Project asset allocation not found."));
            return Ok(ApiResponseHelper.Success(
                data, "Project asset allocation details retrieved successfully."));

        }

        [HttpPost]
        public async Task<IActionResult> Save(ProjAssetAllocationRequest request)
        {
            var result = await _projAssetAllocationService.SaveAsync(request);

            return Ok(ApiResponseHelper.Success(
                result,
                "Project asset allocation saved successfully."
            ));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, ProjAssetAllocationRequest request)
        {
            var result = await _projAssetAllocationService.UpdateAsync(id, request);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Project asset allocation not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Project asset allocation updated successfully."
            ));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _projAssetAllocationService.DeleteAsync(id);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Project asset allocation not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Project asset allocation deleted successfully."
            ));
        }

        [HttpPatch("{id}/deallocate")]
        public async Task<IActionResult> Deallocate(int id)
        {
            var result = await _projAssetAllocationService.DeallocateAsync(id);
            if (result == null)
                return NotFound(ApiResponseHelper.Failure<object>("Project asset allocation not found."));
            return Ok(ApiResponseHelper.Success(result, "Asset deallocated successfully."));
        }
    }
}
