using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.Operator;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;

namespace PNM.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class OperatorController : ControllerBase
    {
        private readonly IOperatorService _operatorService;

        public OperatorController(IOperatorService operatorService)
        {
            _operatorService = operatorService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _operatorService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(
                data, "Operator list retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _operatorService.GetByIdAsync(id);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("Operator not found."));
            return Ok(ApiResponseHelper.Success(
                data, "Operator details retrieved successfully."));

        }

        [HttpPost]
        public async Task<IActionResult> Save(OperatorRequest request)
        {
            var result = await _operatorService.SaveAsync(request);

            return Ok(ApiResponseHelper.Success(
                result,
                "Operator saved successfully."
            ));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, OperatorRequest request)
        {
            var result = await _operatorService.UpdateAsync(id, request);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Operator not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Operator updated successfully."
            ));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _operatorService.DeleteAsync(id);

            if (result == null)
            {
                return NotFound(ApiResponseHelper.Failure<object>("Operator not found."));
            }

            return Ok(ApiResponseHelper.Success(
                result,
                "Operator deleted successfully."
            ));
        }
    }
}
