using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.FuelLog;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;
using System.Threading.Tasks;

namespace PNM.API.Controllers
{
    //[Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class FuelLogController : ControllerBase
    {
        private readonly IFuelLogService _fuelLogService;

        public FuelLogController(IFuelLogService fuelLogService)
        {
            _fuelLogService = fuelLogService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _fuelLogService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(data, "Fuel logs retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _fuelLogService.GetByIdAsync(id);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("Fuel log not found."));
            return Ok(ApiResponseHelper.Success(data, "Fuel log details retrieved successfully."));
        }

        [HttpPost]
        public async Task<IActionResult> Save(FuelLogRequest request)
        {
            var result = await _fuelLogService.SaveAsync(request);
            return Ok(ApiResponseHelper.Success(result, "Fuel log saved successfully."));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, FuelLogRequest request)
        {
            var result = await _fuelLogService.UpdateAsync(id, request);
            if (result == null)
                return NotFound(ApiResponseHelper.Failure<object>("Fuel log not found."));
            return Ok(ApiResponseHelper.Success(result, "Fuel log updated successfully."));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _fuelLogService.DeleteAsync(id);
            if (result == null)
                return NotFound(ApiResponseHelper.Failure<object>("Fuel log not found."));
            return Ok(ApiResponseHelper.Success(result, "Fuel log deleted successfully."));
        }
    }
}
