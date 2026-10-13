package lk.sasindi.globaltrade.test;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;


class InventoryReplenishmentRuleTest {


    @Test
    void lowStockShouldCalculateTargetCorrectly() {

        int current = 3;
        int reorderLevel = 5;


        int target =
                Math.max(
                        reorderLevel * 2,
                        10
                );


        int quantityToAdd =
                Math.max(
                        target - current,
                        0
                );


        assertEquals(
                10,
                target
        );


        assertEquals(
                7,
                quantityToAdd
        );
    }


    @Test
    void targetShouldNeverBeBelowTen() {

        int current = 1;
        int reorderLevel = 2;


        int target =
                Math.max(
                        reorderLevel * 2,
                        10
                );


        assertEquals(
                10,
                target
        );
    }


    @Test
    void quantityToAddShouldNeverBeNegative() {

        int current = 20;
        int reorderLevel = 5;


        int target =
                Math.max(
                        reorderLevel * 2,
                        10
                );


        int quantityToAdd =
                Math.max(
                        target - current,
                        0
                );


        assertEquals(
                0,
                quantityToAdd
        );
    }
}

