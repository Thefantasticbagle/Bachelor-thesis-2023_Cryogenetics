package cryogenetics.logistics.ui.inventory

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import cryogenetics.logistics.R
import cryogenetics.logistics.api.ApiCalls
import cryogenetics.logistics.databinding.FragmentMiniInventoryBinding
import cryogenetics.logistics.functions.Functions
import cryogenetics.logistics.functions.JsonAdapter

class MiniInventoryFragment(
    private val tvInventoryClient: Boolean = false
) : Fragment() {

    private var _binding : FragmentMiniInventoryBinding? = null
    private val binding get() = _binding!!

    private lateinit var inventoryList: RecyclerView
    private lateinit var mProductListAdapter: JsonAdapter

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentMiniInventoryBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // initialize the recyclerView
        binding.InventoryRecycler.layoutManager = LinearLayoutManager(requireContext())
        binding.InventoryRecycler.setHasFixedSize(true)

        if (tvInventoryClient) binding.tvInventoryClient.visibility = View.VISIBLE

        // initialize the recyclerView-adapter
        val itemList = mutableListOf<Map<String, Any>>()
        //Fetch json data and add to itemlist

        for (model in ApiCalls.fetchInventoryData())
            itemList.add( if (model.isNotEmpty()) Functions.enforceNumberFormat(model) else model )

        //Create a list of references
        val viewIds = listOf(
            R.id.tvInventoryNr,
            R.id.tvInventoryClient,
            R.id.tvInventoryLastFill,
            R.id.tvInventoryNoti
        )
        //Create adapter
        binding.InventoryRecycler.adapter = JsonAdapter(itemList, viewIds, R.layout.mini_inventory_recycler_item, tvInventoryClient = tvInventoryClient)
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }

}