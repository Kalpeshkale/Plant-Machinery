using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.ServiceArea;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;

namespace PNM.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class ServiceAreaController : ControllerBase
    {
        private readonly IServiceAreaService _serviceAreaService;

        public ServiceAreaController(IServiceAreaService serviceAreaService)
        {
            _serviceAreaService = serviceAreaService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _serviceAreaService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(
                data, "Service area list retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _serviceAreaService.GetByIdAsync(id);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("Service area not found."));
            return Ok(ApiResponseHelper.Success(
                data, "Service area details retrieved successfully."));

        }

        [HttpPost]
        public async Task<IActionResult> Save(ServiceAreaRequest request)
        {
            var result = await _serviceAreaService.SaveAsync(request);

            return Ok(ApiResponseHelper.Success(
                result,
                "Service area saved successfully."
            ));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, ServiceAreaRequest request)
        {
            var result = await _serviceAreaService.UpdateAsync(id, request);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Service area not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Service area updated successfully."
            ));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _serviceAreaService.DeleteAsync(id);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Service area not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Service area deleted successfully."
            ));
        }
    }
}
