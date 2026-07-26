using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.AssetCompliance;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;
using System.Threading.Tasks;

namespace PNM.API.Controllers
{
    //[Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class AssetComplianceController : ControllerBase
    {
        private readonly IAssetComplianceService _assetComplianceService;

        public AssetComplianceController(IAssetComplianceService assetComplianceService)
        {
            _assetComplianceService = assetComplianceService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _assetComplianceService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(data, "Compliance records retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _assetComplianceService.GetByIdAsync(id);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("Compliance record not found."));
            return Ok(ApiResponseHelper.Success(data, "Compliance details retrieved successfully."));
        }

        [HttpPost]
        public async Task<IActionResult> Save(AssetComplianceRequest request)
        {
            var result = await _assetComplianceService.SaveAsync(request);
            return Ok(ApiResponseHelper.Success(result, "Compliance record saved successfully."));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, AssetComplianceRequest request)
        {
            var result = await _assetComplianceService.UpdateAsync(id, request);
            if (result == null)
                return NotFound(ApiResponseHelper.Failure<object>("Compliance record not found."));
            return Ok(ApiResponseHelper.Success(result, "Compliance record updated successfully."));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _assetComplianceService.DeleteAsync(id);
            if (result == null)
                return NotFound(ApiResponseHelper.Failure<object>("Compliance record not found."));
            return Ok(ApiResponseHelper.Success(result, "Compliance record deleted successfully."));
        }
    }
}
