import 'package:eventique_company_app/providers/services_list.dart';
import 'package:provider/provider.dart';

import '/color.dart';
import 'package:flutter/material.dart';

class Description extends StatefulWidget {
  Description({
    super.key,
    required this.description,
    required this.price,
    required this.category,
    required this.isVisisble,
    required this.isDiscounted, 
    required this.serviceId,
  });
  final String description;
  final double price;
  final String category;
  final int serviceId;
  bool isVisisble, isDiscounted;

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  Widget build(BuildContext context) {
     final provider=Provider.of<AllServices>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Price',
                style: TextStyle(
                  color: Color.fromARGB(255, 226, 147, 168),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '\$${widget.price}',
                  style: const TextStyle(
                      color: primary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              // const Spacer(),
              const SizedBox(),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              const Text(
                'Category',
                style: TextStyle(
                  color: Color.fromARGB(255, 226, 147, 168),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  widget.category,
                  style: const TextStyle(
                      color: primary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              // const Spacer(),
              const SizedBox(),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
           Row(
            children: [
              const Text(
                'Visible to customres?',
                style: TextStyle(
                  color: Color.fromARGB(255, 226, 147, 168),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Switch(
                value: widget.isVisisble,
                onChanged: (value) {
                  if(value==true){
                    provider.editActivation(false, widget.serviceId);
                  }
                  else{
                    provider.editActivation(true, widget.serviceId);
                  }
                  setState(() {
                    widget.isVisisble = value;
                  });
                },
                activeColor: primary,
              ),
              // const Spacer(),
              const SizedBox(),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              const Text(
                'Included in discounted packages',
                style: TextStyle(
                  color: Color.fromARGB(255, 226, 147, 168),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  widget.isDiscounted == true ? 'Yes' : 'No',
                  style: const TextStyle(
                      color: primary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              // const Spacer(),
              const SizedBox(),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            'Description',
            style: TextStyle(
              color: Color.fromARGB(255, 226, 147, 168),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            widget.description,
            style: const TextStyle(
              color: primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
