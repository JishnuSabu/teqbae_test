import 'package:flutter/material.dart';
import 'package:teqbae_test/core/utils/extensions.dart';

class Validators {
  static FormFieldValidator<String> emptyPasswordValidator() {
    return (value) {
      if (value == null || value.isEmpty || value.trim().isEmpty) {
        return "Invalid password";
      } else {
        return null;
      }
    };
  }

  static FormFieldValidator<String> confirmPasswordValidator(
    TextEditingController passwordController,
  ) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return "Confirm password is required";
      }

      if (value != passwordController.text.trim()) {
        return "Passwords do not match";
      }

      return null;
    };
  }

  static FormFieldValidator<String> mobileNumberValidator() {
    return (value) {
      if (value == null || value.isEmpty) {
        return "Invalid Phone number";
      } else if (value.length != 10) {
        return "Invalid Phone number";
      } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        return "Invalid Phone number";
      } else if (value.startsWith("0")) {
        return "Invalid Phone number";
      } else {
        return null;
      }
    };
  }

  static FormFieldValidator<String> leaveReasonValidator() {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Reason is required';
      }
      final regex = RegExp(r'^[a-zA-Z\s]+$');
      if (!regex.hasMatch(value.trim())) {
        return 'Only alphabets and spaces are allowed';
      }
      return null;
    };
  }

  static FormFieldValidator<String> nameValidator(String data) {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter $data name';
      }
      if (value.trim().length < 3) {
        return '${data.capitalizeFirstLetter()} name must be at least 3 characters';
      }
      return null;
    };
  }

  static FormFieldValidator<String> emptyPhoneNumberValidator(String data) {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter $data number';
      }
      if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
        return 'Please enter a valid 10-digit number';
      }
      return null;
    };
  }

  static FormFieldValidator<String> doctorPhoneNumberValidator() {
    return (value) {
      if (value != null && value.isNotEmpty) {
        // Must be 10 digits and numeric
        if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
          return 'Please enter a valid 10-digit number';
        }
        // Disallow numbers starting with 0
        if (value.startsWith('0')) {
          return 'Phone number cannot start with 0';
        }
      }
      return null;
    };
  }

  static FormFieldValidator<String> emailValidator() {
    return (value) {
      if (value != null && value.isNotEmpty) {
        if (!value.contains('@') || !value.contains('.')) {
          return 'Please enter a valid email';
        }
      }
      return null;
    };
  }

  static FormFieldValidator<String> requiredEmailValidator() {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter email address';
      }
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value.trim())) {
        return 'Please enter a valid email address';
      }
      return null;
    };
  }

  static FormFieldValidator<String> addressValidator() {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter address';
      }
      if (value.trim().length < 3) {
        return 'Address must be at least 3 characters';
      }
      return null;
    };
  }

  static FormFieldValidator<String> remarkValidator(String data) {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter $data';
      }
      if (value.trim().length < 3) {
        return '$data must be at least 3 characters';
      }
      return null;
    };
  }

  static FormFieldValidator<String> optionalRemarkValidator(String data) {
    return (value) {
      if (value != null && value.isNotEmpty) {
        if (value.trim().length < 3) {
          return '$data must be at least 3 characters';
        }
      }

      return null;
    };
  }

  static FormFieldValidator<String> pincodeValidator() {
    return (value) {
      if (value != null && value.isNotEmpty) {
        if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(value)) {
          return 'Enter a valid 6-digit pincode';
        }
      }

      return null;
    };
  }

  static FormFieldValidator<String> gstValidator() {
    return (value) {
      if (value != null && value.isNotEmpty) {
        if (!RegExp(
          r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
        ).hasMatch(value.toUpperCase())) {
          return 'Enter a valid GST number';
        }
      }
      return null;
    };
  }

  static FormFieldValidator<String> amountValidator() {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter Amount';
      }
      return null;
    };
  }

  static FormFieldValidator<String> optionalAmountValidator() {
    return (value) {
      if (value != null && value.isNotEmpty) {
        if (value.trim().length < 3) {
          return 'Please enter Amount';
        }
        return null;
      }
      return null;
    };
  }

  static FormFieldValidator<String> emptyNameValidator() {
    return (value) {
      if (value != null && value.isNotEmpty) {
        if (value.trim().length < 3) {
          return 'Name must be at least 3 characters';
        }
      }
      return null;
    };
  }

  static FormFieldValidator<String> kilometerValidator() {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Enter kilometers';
      }

      final km = double.tryParse(value);

      if (km == null) {
        return 'Enter valid number';
      }

      if (km <= 0) {
        return 'Kilometer must be greater than 0';
      }

      return null;
    };
  }

  static FormFieldValidator<String> patientNameValidator() {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter patient name';
      }
      if (value.trim().length < 3) {
        return 'Patient name must be at least 3 characters';
      }
      return null;
    };
  }

  static FormFieldValidator<String> numberFieldValidator(
    String fieldName, {
    int? minLength,
    int? maxLength,
    bool numbersOnly = false,
  }) {
    return (value) {
      if (value != null && value.isNotEmpty) {
        final text = value.trim();
        if (minLength != null && text.length < minLength) {
          return '$fieldName must be at least $minLength characters';
        }

        // max length check
        if (maxLength != null && text.length > maxLength) {
          return '$fieldName must be less than $maxLength characters';
        }

        // numbers only check (for cheque if needed)
        if (numbersOnly && !RegExp(r'^[0-9]+$').hasMatch(text)) {
          return '$fieldName must contain only numbers';
        }
      }

      // min length check

      return null;
    };
  }
}
