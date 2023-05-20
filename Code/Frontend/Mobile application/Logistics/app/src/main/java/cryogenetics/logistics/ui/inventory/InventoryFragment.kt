package cryogenetics.logistics.ui.inventory

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.Button
import androidx.fragment.app.Fragment
import androidx.fragment.app.commit
import androidx.recyclerview.widget.LinearLayoutManager
import cryogenetics.logistics.R
import cryogenetics.logistics.api.Api
import cryogenetics.logistics.api.ApiUrl
import cryogenetics.logistics.databinding.FragmentInventoryBinding
import cryogenetics.logistics.ui.filters.FilterManager
import cryogenetics.logistics.functions.Functions.Companion.enforceNumberFormat
import cryogenetics.logistics.functions.JsonAdapter

class InventoryFragment : Fragment() {
    private lateinit var mInventoryFilterFragment: InventoryFilterFragment
    private lateinit var mAdapter: JsonAdapter

    private var _binding: FragmentInventoryBinding? = null
    private val binding get() = _binding!!
    private var filterManager: FilterManager = FilterManager()
    private var invFragInitialized = false
    private var invData: String = ""

        private val mOnProductClickListener =
        AdapterView.OnItemClickListener { parent, view, position, id ->

            /*
            fun onUpdate(position: Int, model: InventoryDataModel) {
                // Add model we want to update to modelToBeUpdated
                modelToBeUpdated.add(model)

                // Set the value of the clicked model in the edit text
                binding.HeaderName?.setText(model.name)
            }

            fun onDelete(model: InventoryDataModel, checkd: Boolean) {
                // We change the value of isChecked to prepare removal.
                model.isChecked = checkd
            }
            */
            // TODO("Not yet implemented")
        }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?,
    ): View {
        _binding = FragmentInventoryBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        // initialize the recyclerView
        binding.InventoryRecycler.layoutManager = LinearLayoutManager(requireContext())
        binding.InventoryRecycler.setHasFixedSize(true)
        fetchInventoryData()

        // Attach listener to filter button
        binding.bFilter.setOnClickListener {
            invData = ""
            // Create filter fragment with an initial filter state
            if (!::mInventoryFilterFragment.isInitialized) {
                mInventoryFilterFragment = InventoryFilterFragment(
                    {},
                    filterManager
                )

                // Add its on apply function
                mInventoryFilterFragment.onApply = {
                    // Close the fragment
                    childFragmentManager.commit {
                        hide(mInventoryFilterFragment)
                    }
                    fetchInventoryData(filterManager.getUrl(ApiUrl.urlContainer))
                }

                childFragmentManager.commit {
                    setReorderingAllowed(true)
                    add(R.id.inventoryFragment, mInventoryFilterFragment, "invF")
                }
                invFragInitialized = true
            } else {
                childFragmentManager.commit {
                    setReorderingAllowed(true)
                    show(mInventoryFilterFragment)
                }
            }
            // Set invData back to empty for onPause
            invData = ""
        }
    }

    /**
     *  Fetches act log data and updates the adapter.
     *
     *  @param forceUrl - url to fetch data from. If left empty, data is fetched from the default url.
     */
    private fun fetchInventoryData(forceUrl: String = "") {
        // Fetch and parse data
        val url = if (forceUrl=="") ApiUrl.urlContainer else forceUrl
        val urlDataString = Api.fetchJsonData(url)
        val parsedData = Api.parseJsonArray(urlDataString)

        // Create a list out of it
        val itemList = mutableListOf<Map<String, Any>>()
        for (model in parsedData)
            itemList.add( if (model.isNotEmpty()) enforceNumberFormat(model) else model )

        // If the adapter doesn't exist, create it
        if (binding.InventoryRecycler.adapter == null) {
            val viewIds = listOf(
                R.id.tvInventoryNr,
                R.id.tvInventoryClient,
                R.id.tvInventoryLocation,
                R.id.tvInventoryInvoice,
                R.id.tvInventoryLastFill,
                R.id.tvInventorySerialNr,
                R.id.tvInventoryNoti,
                R.id.tvInventoryStatus
            )
            mAdapter = JsonAdapter(itemList, viewIds, R.layout.inventory_recycler_item)
            binding.InventoryRecycler.adapter = mAdapter
            // Otherwise, update its data
        } else {
            mAdapter.updateData(itemList)
        }
    }

    /**
     * Handles a pause event, by storing data that would otherwise be lost.
     */
    override fun onPause() {
        super.onPause()
        if (invFragInitialized) { // Avoid risk of RuntimeException
            // Find fragment by using the tag
            mInventoryFilterFragment = (childFragmentManager.findFragmentByTag("invF")
                ?: throw RuntimeException("Could not find Tag")) as InventoryFilterFragment
            childFragmentManager.commit {
                remove(mInventoryFilterFragment)
            } // Remove Fragment to save resources
            childFragmentManager.popBackStack()

            if (invData == "") // If the user has changed the data, get the data from filterManager.
                invData = filterManager.getUrl(ApiUrl.urlContainer)
        }
    }

    /**
     * Handles restoring values back to the state before user left the tab.
     */
    override fun onResume() {
        super.onResume()
        if (invFragInitialized) {
            // If the invFrag has been initialized, we want to restore its state.
            childFragmentManager.commit {
                setReorderingAllowed(true)
                add(R.id.inventoryFragment, mInventoryFilterFragment, "invF")
            }

            // Here we are reconfiguring onApply to call update data with the last state of the fragment.
            // We also hide/close the fragment, which we just opened to restore its state.
            mInventoryFilterFragment.onApply = {
                childFragmentManager.commit {
                    hide(mInventoryFilterFragment)
                }
                if (invData == "") // It should always be empty unless there is a tab open in users view.
                    fetchInventoryData(filterManager.getUrl(ApiUrl.urlContainer)) // Normal fetch data with filter.
                else
                    fetchInventoryData(invData) // Restore the last state of the table.


            }
        }
    }
}