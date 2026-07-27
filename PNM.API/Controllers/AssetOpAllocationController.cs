using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.AssetOpAllocation;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;

namespace PNM.API.Controllers
{
    [AllowAnonymous]
    [ApiController]
    [Route("api/[controller]")]
    public class AssetOpAllocationController : ControllerBase
    {
        private readonly IAssetOpAllocationService _assetOpAllocationService;

        public AssetOpAllocationController(IAssetOpAllocationService assetOpAllocationService)
        {
            _assetOpAllocationService = assetOpAllocationService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _assetOpAllocationService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(
                data, "Asset operator allocation list retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _assetOpAllocationService.GetByIdAsync(id);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("Asset operator allocation not found."));
            return Ok(ApiResponseHelper.Success(
                data, "Asset operator allocation details retrieved successfully."));

        }

        [HttpPost]
        public async Task<IActionResult> Save(AssetOpAllocationRequest request)
        {
            var result = await _assetOpAllocationService.SaveAsync(request);

            return Ok(ApiResponseHelper.Success(
                result,
                "Asset operator allocation saved successfully."
            ));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, AssetOpAllocationRequest request)
        {
            var result = await _assetOpAllocationService.UpdateAsync(id, request);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Asset operator allocation not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Asset operator allocation updated successfully."
            ));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _assetOpAllocationService.DeleteAsync(id);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Asset operator allocation not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Asset operator allocation deleted successfully."
            ));
        }

        [HttpPatch("{id}/deallocate")]
        public async Task<IActionResult> Deallocate(int id)
        {
            var result = await _assetOpAllocationService.DeallocateAsync(id);
            if (result == null)
                return NotFound(ApiResponseHelper.Failure<object>("Asset operator allocation not found."));
            return Ok(ApiResponseHelper.Success(result, "Operator released from machine successfully."));
        }
    }
}
