using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.Asset;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;

namespace PNM.API.Controllers
{
    //S[Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class AssetController : ControllerBase
    {
        private readonly IAssetService _assetService;

        public AssetController(IAssetService assetService)
        {
            _assetService = assetService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _assetService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(
                data, "Asset list retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _assetService.GetByIdAsync(id);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("Asset not found."));
            return Ok(ApiResponseHelper.Success(
                data, "Asset details retrieved successfully."));

        }

        [HttpPost]
        public async Task<IActionResult> Save(AssetRequest request)
        {
            var result = await _assetService.SaveAsync(request);

            return Ok(ApiResponseHelper.Success(
                result,
                "Asset saved successfully."
            ));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, AssetRequest request)
        {
            var result = await _assetService.UpdateAsync(id, request);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Asset not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Asset updated successfully."
            ));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _assetService.DeleteAsync(id);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Asset not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Asset deleted successfully."
            ));
        }

        [HttpPut("{id}/status/{status}")]
        public async Task<IActionResult> UpdateStatus(int id, string status)
        {
            var result = await _assetService.UpdateStatusAsync(id, status);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Asset not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                $"Asset status updated to {status} successfully."
            ));
        }
    }
}
