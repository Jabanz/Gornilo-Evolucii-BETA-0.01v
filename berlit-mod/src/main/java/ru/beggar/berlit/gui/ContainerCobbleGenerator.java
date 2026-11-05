package ru.beggar.berlit.gui;

import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.entity.player.InventoryPlayer;
import net.minecraft.inventory.Container;
import net.minecraft.inventory.Slot;
import net.minecraft.item.ItemStack;

import ru.beggar.berlit.tileentity.TileEntityCobbleGenerator;
import ru.beggar.berlit.upgrade.UpgradeHelper;

public class ContainerCobbleGenerator extends Container {

    private static final int SLOT_SIZE = 18;

    private final TileEntityCobbleGenerator tile;

    public ContainerCobbleGenerator(InventoryPlayer playerInventory, TileEntityCobbleGenerator tile) {
        this.tile = tile;

        addSlotToContainer(new Slot(tile, TileEntityCobbleGenerator.SLOT_OUTPUT, 62, 35) {

            @Override
            public boolean isItemValid(ItemStack stack) {
                return false;
            }
        });

        for (int i = 0; i < TileEntityCobbleGenerator.SLOT_UPGRADE_COUNT; i++) {
            addSlotToContainer(
                new Slot(tile, TileEntityCobbleGenerator.SLOT_UPGRADE_START + i, 98 + i * SLOT_SIZE, 59) {

                    @Override
                    public boolean isItemValid(ItemStack stack) {
                        return UpgradeHelper.isMachineUpgrade(stack);
                    }
                });
        }

        for (int row = 0; row < 3; row++) {
            for (int col = 0; col < 9; col++) {
                addSlotToContainer(
                    new Slot(playerInventory, col + row * 9 + 9, 8 + col * SLOT_SIZE, 84 + row * SLOT_SIZE));
            }
        }
        for (int col = 0; col < 9; col++) {
            addSlotToContainer(new Slot(playerInventory, col, 8 + col * SLOT_SIZE, 142));
        }
    }

    @Override
    public boolean canInteractWith(EntityPlayer player) {
        return tile.isUseableByPlayer(player);
    }

    @Override
    public ItemStack transferStackInSlot(EntityPlayer player, int index) {
        ItemStack result = null;
        Slot slot = (Slot) inventorySlots.get(index);

        if (slot != null && slot.getHasStack()) {
            ItemStack stack = slot.getStack();
            result = stack.copy();

            int machineSlots = TileEntityCobbleGenerator.SLOT_COUNT;
            if (index < machineSlots) {
                if (!mergeItemStack(stack, machineSlots, inventorySlots.size(), true)) return null;
            } else if (UpgradeHelper.isMachineUpgrade(stack)) {
                if (!mergeItemStack(stack, TileEntityCobbleGenerator.SLOT_UPGRADE_START, machineSlots, false)) {
                    return null;
                }
            } else {
                return null;
            }

            if (stack.stackSize == 0) {
                slot.putStack(null);
            } else {
                slot.onSlotChanged();
            }
        }

        return result;
    }
}
