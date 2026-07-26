using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.DailyLog;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;

namespace PNM.API.Controllers
{
    //[Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class DailyLogController : ControllerBase
    {
        private readonly IDailyLogService _dailyLogService;

        public DailyLogController(IDailyLogService dailyLogService)
        {
            _dailyLogService = dailyLogService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _dailyLogService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(
                data, "Daily log list retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _dailyLogService.GetByIdAsync(id);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("Daily log not found."));
            return Ok(ApiResponseHelper.Success(
                data, "Daily log details retrieved successfully."));

        }

        [HttpPost]
        public async Task<IActionResult> Save(DailyLogRequest request)
        {
            var result = await _dailyLogService.SaveAsync(request);

            return Ok(ApiResponseHelper.Success(
                result,
                "Daily log saved successfully."
            ));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, DailyLogRequest request)
        {
            var result = await _dailyLogService.UpdateAsync(id, request);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Daily log not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Daily log updated successfully."
            ));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _dailyLogService.DeleteAsync(id);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Daily log not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Daily log deleted successfully."
            ));
        }

        [HttpPut("{id}/sic-approval/{sicBy}")]
        public async Task<IActionResult> SicApproval(int id, int sicBy, DailyLogApprovalRequest request)
        {
            var result = await _dailyLogService.SicApprovalAsync(id, sicBy, request);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Daily log not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Daily log SIC approval updated successfully."
            ));
        }

        [HttpPut("{id}/admin-approval/{adminBy}")]
        public async Task<IActionResult> AdminApproval(int id, int adminBy, DailyLogApprovalRequest request)
        {
            var result = await _dailyLogService.AdminApprovalAsync(id, adminBy, request);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Daily log not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Daily log admin approval updated successfully."
            ));
        }

        [HttpGet("asset-details/{assetId}")]
        public async Task<IActionResult> GetAssetDetails(int assetId)
        {
            var data = await _dailyLogService.GetAssetLoggingDetailsAsync(assetId);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("Asset details not found."));
            return Ok(ApiResponseHelper.Success(data, "Asset details for logging retrieved successfully."));
        }

        [HttpPost("bulk")]
        public async Task<IActionResult> SaveBulk(List<DailyLogRequest> requests)
        {
            var result = await _dailyLogService.SaveBulkAsync(requests);
            return Ok(ApiResponseHelper.Success(result, "Bulk daily logs saved successfully."));
        }
    }
}
