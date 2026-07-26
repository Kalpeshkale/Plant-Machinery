using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PNM.Core.DTO.ConcreteEntry;
using PNM.Service.Services.Interfaces;
using PNM.Shared.Response;
using System.Threading.Tasks;

namespace PNM.API.Controllers
{
    //[Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class ConcreteEntryController : ControllerBase
    {
        private readonly IConcreteEntryService _concreteEntryService;

        public ConcreteEntryController(IConcreteEntryService concreteEntryService)
        {
            _concreteEntryService = concreteEntryService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var data = await _concreteEntryService.GetAllAsync();
            return Ok(ApiResponseHelper.Success(data, "Concrete entries retrieved successfully."));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var data = await _concreteEntryService.GetByIdAsync(id);
            if (data == null)
                return NotFound(ApiResponseHelper.Failure<object>("Concrete entry not found."));
            return Ok(ApiResponseHelper.Success(data, "Concrete entry details retrieved successfully."));
        }

        [HttpPost]
        public async Task<IActionResult> Save(ConcreteEntryRequest request)
        {
            var result = await _concreteEntryService.SaveAsync(request);
            return Ok(ApiResponseHelper.Success(result, "Concrete entry saved successfully."));
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, ConcreteEntryRequest request)
        {
            var result = await _concreteEntryService.UpdateAsync(id, request);
            if (result == null)
                return NotFound(ApiResponseHelper.Failure<object>("Concrete entry not found."));
            return Ok(ApiResponseHelper.Success(result, "Concrete entry updated successfully."));
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _concreteEntryService.DeleteAsync(id);
            if (result == null)
                return NotFound(ApiResponseHelper.Failure<object>("Concrete entry not found."));
            return Ok(ApiResponseHelper.Success(result, "Concrete entry deleted successfully."));
        }
    }
}
