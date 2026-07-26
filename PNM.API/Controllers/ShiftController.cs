using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.Shift;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;

namespace PNM.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class ShiftController : ControllerBase
    {
        private readonly IShiftService _shiftService;

        public ShiftController(IShiftService shiftService)
        {
            _shiftService = shiftService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _shiftService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(
                data, "Shift list retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _shiftService.GetByIdAsync(id);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("Shift not found."));
            return Ok(ApiResponseHelper.Success(
                data, "Shift details retrieved successfully."));

        }

        [HttpPost]
        public async Task<IActionResult> Save(ShiftRequest request)
        {
            var result = await _shiftService.SaveAsync(request);

            return Ok(ApiResponseHelper.Success(
                result,
                "Shift saved successfully."
            ));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, ShiftRequest request)
        {
            var result = await _shiftService.UpdateAsync(id, request);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Shift not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Shift updated successfully."
            ));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _shiftService.DeleteAsync(id);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Shift not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Shift deleted successfully."
            ));
        }
    }
}
