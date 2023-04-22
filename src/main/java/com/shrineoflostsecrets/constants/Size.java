package com.shrineoflostsecrets.constants;

public enum Size {
    SIZE_1024x1024("1024x1024"),
    SIZE_512x512("512x512"),
    SIZE_128x128("128x128");

    private final String size;

    private Size(String size) {
        this.size = size;
    }

    public String getSize() {
        return size;
    }
    public static Size isValidSize(String inputSize) {
        for (Size size : Size.values()) {
            if (size.getSize().equals(inputSize)) {
                return size;
            }
        }
        return SIZE_1024x1024;
    }
}