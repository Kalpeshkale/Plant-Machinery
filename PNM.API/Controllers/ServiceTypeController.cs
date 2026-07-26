using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.ServiceType;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;

namespace PNM.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class ServiceTypeController : ControllerBase
    {
        private readonly IServiceTypeService _serviceTypeService;

        public ServiceTypeController(IServiceTypeService serviceTypeService)
        {
            _serviceTypeService = serviceTypeService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _serviceTypeService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(
                data, "Service type list retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _serviceTypeService.GetByIdAsync(id);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("Service type not found."));
            return Ok(ApiResponseHelper.Success(
                data, "Service type details retrieved successfully."));

        }

        [HttpPost]
        public async Task<IActionResult> Save(ServiceTypeRequest request)
        {
            var result = await _serviceTypeService.SaveAsync(request);

            return Ok(ApiResponseHelper.Success(
                result,
                "Service type saved successfully."
            ));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, ServiceTypeRequest request)
        {
            var result = await _serviceTypeService.UpdateAsync(id, request);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Service type not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Service type updated successfully."
            ));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _serviceTypeService.DeleteAsync(id);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Service type not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Service type deleted successfully."
            ));
        }
    }
}
