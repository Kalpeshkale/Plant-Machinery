using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.SubType;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;

namespace PNM.API.Controllers
{
    //[Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class SubTypeController : ControllerBase
    {
        private readonly ISubTypeService _subTypeService;

        public SubTypeController(ISubTypeService subTypeService)
        {
            _subTypeService = subTypeService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _subTypeService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(
                data, "SubType list retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _subTypeService.GetByIdAsync(id);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("SubType not found."));
            return Ok(ApiResponseHelper.Success(
                data, "SubType details retrieved successfully."));

        }

        [HttpPost]
        public async Task<IActionResult> Save(SubTypeRequest request)
        {
            var result = await _subTypeService.SaveAsync(request);

            return Ok(ApiResponseHelper.Success(
                result,
                "SubType saved successfully."
            ));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, SubTypeRequest request)
        {
            var result = await _subTypeService.UpdateAsync(id, request);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("SubType not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "SubType updated successfully."
            ));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _subTypeService.DeleteAsync(id);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("SubType not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "SubType deleted successfully."
            ));
        }
    }
}
