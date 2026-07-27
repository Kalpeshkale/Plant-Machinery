using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.OwnerType;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;

namespace PNM.API.Controllers
{
    //[Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class OwnerTypeController : ControllerBase
    {
        private readonly IOwnerTypeService _ownerTypeService;

        public OwnerTypeController(IOwnerTypeService ownerTypeService)
        {
            _ownerTypeService = ownerTypeService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _ownerTypeService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(
                data, "Ownership type list retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _ownerTypeService.GetByIdAsync(id);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("Ownership type not found."));
            return Ok(ApiResponseHelper.Success(
                data, "Ownership type details retrieved successfully."));

        }

        [HttpPost]
        public async Task<IActionResult> Save(OwnerTypeRequest request)
        {
            var result = await _ownerTypeService.SaveAsync(request);

            return Ok(ApiResponseHelper.Success(
                result,
                "Ownership type saved successfully."
            ));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, OwnerTypeRequest request)
        {
            var result = await _ownerTypeService.UpdateAsync(id, request);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Ownership type not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Ownership type updated successfully."
            ));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _ownerTypeService.DeleteAsync(id);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Ownership type not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Ownership type deleted successfully."
            ));
        }
    }
}
